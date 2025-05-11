/**
 * @jest-environment jsdom
 */
import { render, screen } from "@testing-library/react";
import Count from "./index";
import { AppProvider } from "@/app/context/AppContext";

describe("count", () => {
  it("renders a count", () => {
    render(
      <AppProvider>
        <Count />
      </AppProvider>);

    const count = screen.getByText(/count:/i);

    expect(count).toBeInTheDocument();
  });
});
