/**
 * @jest-environment jsdom
 */
import { render, screen } from "@testing-library/react";
import About from "./index";

describe("About", () => {
  it("renders a about", () => {
    render(<About />);

    const about = screen.getByRole("heading", {
      name: /About/i,
    });

    expect(about).toBeInTheDocument();
  });
});
